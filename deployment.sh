echo "Deploying to production..."
echo "Started switching pubspect files..."
echo "actual folders"
ls
rm pubspec.yaml
rm pubspec.lock
rm -rf build
mv pubspec_deploy.yaml pubspec.yaml
echo "final folders"
ls
echo "content"
tail -n 20 pubspec.yaml
echo "Finished switching pubspect files..."
