echo "Deploying to production..."
echo "Started switching pubspect files..."
rm pubspec.yaml
rm pubspec.lock
rm -rf build
mv pubspec_deploy.yaml pubspec.yaml
echo "Finished switching pubspect files..."
