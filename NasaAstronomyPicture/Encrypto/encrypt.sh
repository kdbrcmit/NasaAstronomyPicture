


env_file_name="SecretKeys"

file_key="3132333435363738393031323334121212383930313233343536373839303132"

# Environment .plist file encription algo

echo write $TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/$env_file_name.enc
openssl enc -aes-256-ecb -md md5 -nosalt -in $PROJECT_DIR/NasaAstronomyPicture/Encrypto/$env_file_name.plist -out $TARGET_BUILD_DIR/$UNLOCALIZED_RESOURCES_FOLDER_PATH/$env_file_name.enc -K $file_key


