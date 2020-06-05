## How to build boost and openssl for Android

```
git clone <this project>
```

### Install dependencies

```
yum -y install make gcc-c++ automake autoconf
```

### Download android NDK

example for version 20b, might be different URL for other NDK version

```
wget https://dl.google.com/android/repository/android-ndk-r20b-linux-x86_64.zip
unzip android-ndk-r20b-linux-x86_64.zip
```

### Compiling boost

Boost-for-Android opensource project provide least boost version compiling way.

```
git clone https://github.com/moritz-wundke/Boost-for-Android.git
cd Boost-for-Android
./build-android.sh <ndk_path>
```

Lib files will appear in build directory, we just need libboost-system???.a and libboost-program-options???.a

### Compiling openssl

```
cd <this project path>

wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1g.zip
unzip OpenSSL_1_1_1g.zip

./make_openssl.sh <ndk_path>
```

./make_openssl.sh was writen for openssl-OpenSSL_1_1_1g, after a while, we will get include/lib in output directory.
