export DIR=$(pwd)
export CROSS_COMPILE=${DIR}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export ARCH=arm
export SUBARCH=arm
export DEFCONFIG="ace_defconfig"

export AK2=${DIR}/Ak2
export DTB=${DIR}/Dtb/dtbTool_moto

make O=out ${DEFCONFIG}
make O=out -j$(nproc --all) LOCALVERSION="-BetaPhase"
