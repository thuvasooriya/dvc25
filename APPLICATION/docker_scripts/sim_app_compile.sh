echo "[i] compiling app.."
cd demo
./build.sh
echo "[i] changing file permissions of built artifacts"
chmod -R 755 build
ls -lah build/
