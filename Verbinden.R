


# In a directory with app.R
list.files()
# [1] "app.R"

# Create the manifest
rsconnect::writeManifest()

# Confirm manifest.json output
list.files()
# [1] "app.R" "manifest.json"