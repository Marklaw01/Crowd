
target "CrowdBootstrap" do
    pod 'QuickBlox'
    pod 'QMServices'
    pod 'QMChatViewController'
    pod 'Reachability'
    pod 'MBProgressHUD'
    pod 'KLCPopup'
    pod 'AFNetworking', '~> 2.0'
    pod 'SHSPhoneComponent'
    pod 'JDFTooltips'
    pod 'TWMessageBarManager'
    pod 'RATreeView', '~> 2.1.0’
    pod 'Google-Mobile-Ads-SDK'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    pod 'google-plus-ios-sdk'
    pod 'IOSLinkedInAPI'
    pod 'TesseractOCRiOS'
    pod 'JPSThumbnailAnnotation'
    pod "youtube-ios-player-helper", "~> 0.1.4"`
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-CrowdBootstrap/Pods-CrowdBootstrap-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end
