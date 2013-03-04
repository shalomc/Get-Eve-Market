echo off
@setlocal enabledelayedexpansion 


echo. 
echo 1. Jita--^>The Forge--^>       30000142 --^> 10000002
echo 2. Oursulaert--^>Essence--^>   30004969 --^> 10000064
echo 3. Rens--^>Heimatar--^>        30002510 --^> 10000030
echo 4. Alentene--^>Verge Vendor--^>30005304 --^> 10000068
echo 5. Dodixie--^>Sinq Laison--^>  30002659 --^> 10000032
echo 6. Hek--^>Metropolis--^>	 30002053 --^> 10000042
echo X. Exit and do nothing
echo.

CHOICE /C 123456X /T 10 /D 1 /M "Select option?"
IF ERRORLEVEL 1 set SOLAR=Jita
IF ERRORLEVEL 2 set SOLAR=Oursulaert
IF ERRORLEVEL 3 set SOLAR=Rens
IF ERRORLEVEL 4 set SOLAR=Alentene
IF ERRORLEVEL 5 set SOLAR=Dodixie
IF ERRORLEVEL 6 set SOLAR=Hek
IF ERRORLEVEL 7 goto done

goto %SOLAR%

:Jita
set EVE_REGION=10000002
set EVE_SOLAR=30000142
goto GET_FROM_EC

:Oursulaert
set EVE_REGION=10000064
set EVE_SOLAR=30004969
goto GET_FROM_EC

:Rens  
set EVE_REGION=10000030
set EVE_SOLAR=30002510
goto GET_FROM_EC

:Alentene 
set EVE_REGION=10000068
set EVE_SOLAR=30005304
goto GET_FROM_EC

:Dodixie
set EVE_REGION=10000032
set EVE_SOLAR=30002659
goto GET_FROM_EC

:Hek 
set EVE_REGION=10000042
set EVE_SOLAR=30002053
goto GET_FROM_EC



:GET_FROM_EC
set EVE_HOME=%CD%
cd \dev\wget\bin

set i=0
set j=1
set EVEFILE=eve-central-%j%
set ECLIST=
set EVECENTRALMERGE=%EVE_HOME%\eve-central-merge-index.xml

echo %DATE% %TIME%      > %EVE_HOME%\ec-trace.txt

echo ^<^?xml version="1.0"  encoding="utf-8" ^?^>     > %EVECENTRALMERGE%
echo ^<^?xml-stylesheet type="text/xsl" href="eve-central-merge-index.xslt" ^?^>    >> %EVECENTRALMERGE%
echo.    >> %EVECENTRALMERGE%
echo ^<index^>    >> %EVECENTRALMERGE%

for /F %%X in (%EVE_HOME%\typeid.txt) do (
	set /a i=!i!+1
	if !i! gtr 40   (
		echo wget -nv -O "!EVE_HOME!\!EVEFILE!.xml" "http://api.eve-central.com/api/marketstat?usesystem=!EVE_SOLAR!!ECLIST!"     >> !EVE_HOME!\ec-trace.txt
		echo wget -nv -O "!EVE_HOME!\!EVEFILE!.xml" "http://api.eve-central.com/api/marketstat?usesystem=!EVE_SOLAR!!ECLIST!"     
		wget -v -a !EVE_HOME!\ec-trace.txt  -O "!EVE_HOME!\!EVEFILE!.xml" "http://api.eve-central.com/api/marketstat?usesystem=!EVE_SOLAR!!ECLIST!"     
		echo -------------------------------------------------------------------------- >> !EVE_HOME!\ec-trace.txt
		echo    ^<entry^>!EVEFILE!^<^/entry^>   >> %EVECENTRALMERGE%
		set i=0
		set ECLIST=
		set /a j=!j!+1
		set EVEFILE=eve-central-!j!
		)
	set  ECLIST=!ECLIST!^&typeid=%%X
	)


	set EVEFILE=eve-central-%j%
	echo wget -nv -O "%EVE_HOME%\%EVEFILE%.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%%ECLIST%"     >> %EVE_HOME%\ec-trace.txt
	wget -v -a %EVE_HOME%\ec-trace.txt  -O "%EVE_HOME%\%EVEFILE%.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%%ECLIST%"    
	echo -------------------------------------------------------------------------- >> %EVE_HOME%\ec-trace.txt
	echo    ^<entry^>%EVEFILE%^<^/entry^>    >> %EVECENTRALMERGE%


echo ^<^/index^>      >> %EVECENTRALMERGE%





:: last is 13 items

cd %EVE_HOME%

:xsl

set PATH=%PATH%;"C:\Program Files\Altova\AltovaXML2010"
echo merging %j% Eve Central Results...
AltovaXML.exe -xslt2 eve-central-merge-index.xslt -in eve-central-merge-index.xml -out eve-central-merged.xml
echo Merged Eve Central data is at %CD%\eve-central-merged.xml
goto done

::usesystem vs regionlimit
:skip the old version 
wget -O "%EVE_HOME%\eve-central-001-050.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=12771&typeid=12633&typeid=439&typeid=438&typeid=434&typeid=440&typeid=11267&typeid=11269&typeid=3538&typeid=3540&typeid=3528&typeid=3530&typeid=523&typeid=1183&typeid=11381&typeid=11379&typeid=11400&typeid=11393&typeid=11365&typeid=11371&typeid=31119&typeid=31117&typeid=16231&typeid=2020&typeid=3504&typeid=1195&typeid=2032&typeid=2203&typeid=2183&typeid=2454&typeid=2464&typeid=2486&typeid=2205&typeid=2456&typeid=2466&typeid=2185&typeid=2488&typeid=22444&typeid=9834&typeid=11688&typeid=16670&typeid=17317&typeid=16673&typeid=16683&typeid=16679&typeid=16682&typeid=16681&typeid=16680&typeid=16678&typeid=16671" 
wget -O "%EVE_HOME%\eve-central-051-100.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=16672&typeid=11549&typeid=11545&typeid=11555&typeid=11551&typeid=11694&typeid=11542&typeid=11547&typeid=11531&typeid=11536&typeid=11535&typeid=11539&typeid=11538&typeid=11548&typeid=11553&typeid=11541&typeid=11695&typeid=11530&typeid=11556&typeid=11540&typeid=11554&typeid=11691&typeid=11544&typeid=11543&typeid=11532&typeid=11534&typeid=11693&typeid=11550&typeid=11689&typeid=11557&typeid=11533&typeid=11692&typeid=11537&typeid=11552&typeid=11690&typeid=11558&typeid=11182&typeid=622&typeid=629&typeid=2046&typeid=2048&typeid=20418&typeid=20410&typeid=20411&typeid=20171&typeid=20424&typeid=20172&typeid=20415&typeid=20416&typeid=20423" 
wget -O "%EVE_HOME%\eve-central-101-150.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=20414&typeid=20420&typeid=21581&typeid=16242&typeid=11387&typeid=15599&typeid=15600&typeid=15601&typeid=1317&typeid=1319&typeid=598&typeid=586&typeid=587&typeid=585&typeid=593&typeid=3828&typeid=3689&typeid=9848&typeid=9838&typeid=9842&typeid=519&typeid=520&typeid=11999&typeid=12015&typeid=12013&typeid=652&typeid=11202&typeid=11196&typeid=11176&typeid=11178&typeid=11198&typeid=11200&typeid=22456&typeid=9944&typeid=10190&typeid=37&typeid=40&typeid=36&typeid=11399&typeid=38&typeid=35&typeid=34&typeid=39&typeid=1875&typeid=1877&typeid=501&typeid=2410&typeid=485&typeid=2881&typeid=2977"
wget -O "%EVE_HOME%\eve-central-151-200.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=2897&typeid=2889&typeid=488&typeid=490&typeid=486&typeid=484&typeid=2873&typeid=32027&typeid=32031&typeid=32025&typeid=32029&typeid=25948&typeid=26374&typeid=31372&typeid=31378&typeid=31358&typeid=31364&typeid=31370&typeid=31376&typeid=31802&typeid=31812&typeid=31800&typeid=31810&typeid=25595&typeid=25605&typeid=25596&typeid=25600&typeid=25622&typeid=25599&typeid=25604&typeid=25591&typeid=25590&typeid=25597&typeid=25592&typeid=25615&typeid=25625&typeid=25601&typeid=25619&typeid=25589&typeid=25603&typeid=25617&typeid=25588&typeid=25593&typeid=25594&typeid=25598&typeid=25606&typeid=10838&typeid=10858&typeid=10836&typeid=10850"
wget -O "%EVE_HOME%\eve-central-201-250.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=3993&typeid=3995&typeid=12034&typeid=11377&typeid=11476&typeid=11475&typeid=11482&typeid=11484&typeid=11478&typeid=11486&typeid=11483&typeid=11481&typeid=1977&typeid=24348&typeid=12747&typeid=12735&typeid=2905&typeid=20421&typeid=25887&typeid=583&typeid=603&typeid=597&typeid=3766&typeid=487&typeid=624&typeid=608&typeid=12625&typeid=630&typeid=22468&typeid=11184&typeid=589&typeid=12608&typeid=22765&typeid=24690&typeid=24694&typeid=11186&typeid=12631&typeid=639&typeid=28665&typeid=653&typeid=22468&typeid=12625&typeid=22468&typeid=12608&typeid=24690&typeid=24694&typeid=12631&typeid=653&typeid=11963"
wget -O "%EVE_HOME%\eve-central-251-300.xml" "http://api.eve-central.com/api/marketstat?usesystem=%EVE_SOLAR%&typeid=20421&typeid=25887&typeid=20418&typeid=20410&typeid=20411&typeid=20171&typeid=20424&typeid=20172&typeid=20415&typeid=20416&typeid=20423&typeid=20414&typeid=20420&typeid=3841&typeid=3685&typeid=3839&typeid=10840&typeid=10842&typeid=483&typeid=482&typeid=20413"


:done
@endlocal

