#!/usr/bin/env bash

# Variables
REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
GH_PAGES_DIR="gh-pages"

# Prepare new docs dir
mkdir -p $GH_PAGES_DIR
cp -r ./submodules/scylladb/docs/_build/dirhtml/. $GH_PAGES_DIR

# Clone or initialize the gh-pages branch
if git ls-remote --heads "$REPO_URL" gh-pages; then
    git clone --branch gh-pages --single-branch "$REPO_URL" "${GH_PAGES_DIR}-existing"
    cd "${GH_PAGES_DIR}-existing"

    # Remove the "manual" folder if it exists
    rm -rf manual

    # Create a new "manual" folder and copy the new docs inside it
    mkdir -p manual
    cp -r ../$GH_PAGES_DIR/* manual/
else
    # Initialize new gh-pages branch
    mkdir -p "${GH_PAGES_DIR}-existing"
    cd "${GH_PAGES_DIR}-existing"
    git init
    git checkout -b gh-pages
fi

# Configure Git
git config --local user.email "action@scylladb.com"
git config --local user.name "GitHub Action"
git remote add origin "$REPO_URL" || true

# Commit and push changes
git add .
git commit -m "Update docs" || true
git push origin gh-pages --force