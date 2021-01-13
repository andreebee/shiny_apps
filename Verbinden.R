
#install.packages("rsconnect")

# In a directory with app.R
list.files(path = "test")


# Create the manifest
rsconnect::writeManifest(appDir = "test")

# Confirm manifest.json output
list.files(path = "test")



