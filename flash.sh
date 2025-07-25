#!bin/sh

if [ $# -lt 3 ]; then
	writeToLogsFile "@@ No 3 arguments passed to ${FUNCNAME[0]}() in ${BASH_SOURCE} called from $( basename ${0} )"
	exit 1
else
	searchAPK ${1} ${2}
	local apkPath=""
	local APK_CHOICE
	local apkOperationChoice="n"
	if [ $Search_APK_COUNT -gt 0 ]; then
		displayAPKlist
		if [ $Search_APK_COUNT -gt 1 ]; then
			formatMessage "\n Enter APK Choice : "
			read APK_CHOICE
			echo " "
			checkAPKChoiceValidity $APK_CHOICE
			apkPath=${APK_ARRAY[$APK_ARRAY_INDEX]}
		elif [ $Search_APK_COUNT -eq 1 ]; then
			apkOperationOptionUppercase=`toUppercase $3`
			if [ "$apkOperationOptionUppercase" == "VERSION" ]; then
				apkPath=${APK_ARRAY[0]}
				echo ""
			else
				formatMessage "\n Do you want to $apkOperationOptionUppercase it ? [y/n] : " "Q"
				stty -echo && read -n 1 apkOperationChoice && stty echo
				formatYesNoOption $apkOperationChoice
				echo ""
				if [ "$( checkYesNoOption $apkOperationChoice )" == "yes" ]; then
					apkPath=${APK_ARRAY[0]}
				elif [ "$( checkYesNoOption $apkOperationChoice )" == "no" ]; then
					echo -e -n "\n"
					exit 1
				fi
			fi
		fi
		splitAPKpath ${apkPath}
		case "$3" in
			[pP][uU][lL][lL])
				pullDeviceApp $1 $apkDevicePath ;;
			[cC][lL][eE][aA][rR])
				clearDeviceApp $1 $apkPackageName ;;
			[sS][tT][oO][pP])
				stopDeviceApp $1 $apkPackageName ;;
			[kK][iI][lL][lL])
				killDeviceApp $1 $apkPackageName ;;
			[sS][tT][aA][rR][tT])
				startDeviceApk $1 $apkPackageName ;;
			[rR][eE][sS][tT][aA][rR][tT])
				restartDeviceApp $1 $apkPackageName ;;
			[uU][nN][iI][nN][sS][tT][aA][lL][lL])
				uninstallSelectedDeviceApp $1 $apkPath ;;
			[uU][nN][iI][nN][sS][tT][aA][lL][lL][uU][pP][dD][aA][tT][eE][sS])
				uninstallDeviceAppUpdates $1 $apkPackageName ;;
			[vV][eE][rR][sS][iI][oO][nN])
				getDeviceAppVersion $1 $apkPackageName ;;
			*)
				writeToLogsFile " Unsupported argument \"${3}\" passed to ${FUNCNAME[0]}() in ${BASH_SOURCE} called from $( basename ${0} ) "
				formatMessage " Unsupported argument passed to ${FUNCNAME[0]}() in ${BASH_SOURCE} called from $( basename ${0} )" "E"
				exit 1 ;;
		esac
	else
		formatMessage " No APKs installed with that name\n" "E"
	fi
fi
