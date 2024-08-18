@echo off
@rem ##########################################################################
@rem # Copyright (C) 2024 kitanokitsune
@rem #
@rem # This program is free software; you can redistribute it and/or
@rem # modify it under the terms of the GNU General Public License
@rem # as published by the Free Software Foundation; either version 2
@rem # of the License, or (at your option) any later version.
@rem #
@rem # This program is distributed in the hope that it will be useful,
@rem # but WITHOUT ANY WARRANTY; without even the implied warranty of
@rem # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@rem # GNU General Public License for more details.
@rem #
@rem # You should have received a copy of the GNU General Public License
@rem # along with this program; if not, write to the Free Software
@rem # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
@rem ##########################################################################



setlocal enabledelayedexpansion

if exist "%~1"  (
cd /d %~dp1
)



@rem ##########################################################################
@rem Gerbv Project Filename
set GVPFILE="000.gvp"
if not "%1" == "" (
set GVPFILE="%~n1.gvp"
)



@rem ##########################################################################
@rem Gerber filenames given by wildcard patterns (Please modify if needed)
@rem Give priority to the ones in the back

set DRILL_FILENAMES=*%~n1.txt *.drd *.xln *.exc *dri.grb *.tap *.drl *anc.drl
set TOP_SILK_FILENAMES=*st.pho *.plc *.tsk *silk_top.grb *.sst *.gto *-F_SilkS.g* *-F_Silkscreen.g*
set TOP_PASTE_FILENAMES=*pt.pho *.mmc *.crc *.tsp *.metalmask_top *.spt *.gtp *-F_Paste.g*
set TOP_RESIST_FILENAMES=*mt.pho *.stc *.tsm *res_top.grb *.smt *.gts *-F_Mask.g*
set TOP_PATTERN_FILENAMES=*l1.pho *.cmp *ptn_top.grb *.top *.gtl *-F_Cu.g*
set L2_PATTERN_FILENAMES=*l2.pho *.2l *.ly2 *.gl2 *ptn_sec.grb *.inner1 *.in1 *.g1 *.gp1 *-In1_Cu.g*
set L3_PATTERN_FILENAMES=*l3.pho *.3l *.ly3 *.l15 *.gl3 *ptn_thi.grb *.inner2 *.in2 *.g2 *.gp2 *-In2_Cu.g*
set BOT_PATTERN_FILENAMES=*l4.pho *.sol *ptn_btm.grb *.bot *.gbl *-B_Cu.g*
set BOT_RESIST_FILENAMES=*mb.pho *.sts *.bsm *res_btm.grb *.smb *.gbs *-B_Mask.g*
set BOT_PASTE_FILENAMES=*pb.pho *.mms *.crs *.bsp *.metalmask_bot *.spb *.gbp *-B_Paste.g*
set BOT_SILK_FILENAMES=*sb.pho *.pls *.bsk *slk_btm.grb *.ssb *.gbo *-B_SilkS.g* *-B_Silkscreen.g*
set BOARD_OUTLINE_FILENAMES=*.out *.dim *.gm3 *.gml *outline.grb *.gko *.fab *.gm1 *-Edge_Cuts.g*



@rem ##########################################################################
@rem Gerbv Viwer Layer Color

set DRILL_COLOR=5911 5911 5911
set TOP_SILK_COLOR=65535 65535 65535
set TOP_PASTE_COLOR=31761 31611 31785
set TOP_RESIST_COLOR=64431 65535 0
set TOP_PATTERN_COLOR=278 65535 0
set L2_PATTERN_COLOR=54741 65021 13107
set L3_PATTERN_COLOR=65535 39144 0
set BOT_PATTERN_COLOR=0 20046 65535
set BOT_RESIST_COLOR=47802 47802 47802
set BOT_PASTE_COLOR=31761 31611 31785
set BOT_SILK_COLOR=54227 54227 65535
set BOARD_OUTLINE_COLOR=34353 34353 34353
set BACKGROUND_COLOR=0 0 0



@rem ##########################################################################
@rem Gerbv Viwer Layer Alpha Blending

set DRILL_ALPHA=65535
set TOP_SILK_ALPHA=33924
set TOP_PASTE_ALPHA=45489
set TOP_RESIST_ALPHA=19275
set TOP_PATTERN_ALPHA=19275
set L2_PATTERN_ALPHA=14649
set L3_PATTERN_ALPHA=19789
set BOT_PATTERN_ALPHA=35980
set BOT_RESIST_ALPHA=45489
set BOT_PASTE_ALPHA=45489
set BOT_SILK_ALPHA=45489
set BOARD_OUTLINE_ALPHA=65535



@rem ##########################################################################
@rem Gerbv Viwer Layer Visible (t=True, f=False)

set DRILL_VISIBLE=t
set TOP_SILK_VISIBLE=t
set TOP_PASTE_VISIBLE=f
set TOP_RESIST_VISIBLE=t
set TOP_PATTERN_VISIBLE=t
set L2_PATTERN_VISIBLE=t
set L3_PATTERN_VISIBLE=t
set BOT_PATTERN_VISIBLE=t
set BOT_RESIST_VISIBLE=f
set BOT_PASTE_VISIBLE=f
set BOT_SILK_VISIBLE=f
set BOARD_OUTLINE_VISIBLE=t



@rem ##########################################################################
@rem Create GVP file

chcp 65001 > nul


@rem Header
echo:^(gerbv-file-version^^! "2.0A"^)> %GVPFILE%



@rem Excellon Drill File
set layernum=0
set FN=
for %%I in (%DRILL_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Excellon Drill File: %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%DRILL_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%DRILL_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%DRILL_ALPHA%^)^)>> %GVPFILE%
echo:	^(cons 'attribs ^(list>> %GVPFILE%
echo:		^(list 'autodetect 'Boolean 1^)>> %GVPFILE%
echo:		^(list 'zero_suppression 'Enum 1^)>> %GVPFILE%
echo:		^(list 'units 'Enum 1^)>> %GVPFILE%
echo:		^(list 'digits 'Integer 3^)>> %GVPFILE%
echo:	^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Top Silkscreen
set FN=
for %%I in (%TOP_SILK_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Top Silkscreen     : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%TOP_SILK_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%TOP_SILK_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%TOP_SILK_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Top Paste
set FN=
for %%I in (%TOP_PASTE_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Top Paste          : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%TOP_PASTE_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%TOP_PASTE_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%TOP_PASTE_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Top Resist Mask
set FN=
for %%I in (%TOP_RESIST_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Top Resist         : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%TOP_RESIST_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%TOP_RESIST_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%TOP_RESIST_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Top Pattern (Layer1)
set FN=
for %%I in (%TOP_PATTERN_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Top Pattern        : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%TOP_PATTERN_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%TOP_PATTERN_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%TOP_PATTERN_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Inner1 Layer Pattern (Layer2)
set FN=
for %%I in (%L2_PATTERN_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	L2 Pattern         : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%L2_PATTERN_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%L2_PATTERN_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%L2_PATTERN_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Inner2 Layer Pattern (Layer3)
set FN=
for %%I in (%L3_PATTERN_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	L3 Pattern         : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%L3_PATTERN_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%L3_PATTERN_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%L3_PATTERN_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Bottom Pattern (Layer4)
set FN=
for %%I in (%BOT_PATTERN_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Bottom Pattern     : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%BOT_PATTERN_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BOT_PATTERN_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%BOT_PATTERN_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Bottom Resist Mask
set FN=
for %%I in (%BOT_RESIST_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Bottom Resist      : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%BOT_RESIST_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BOT_RESIST_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%BOT_RESIST_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Bottom Paste
set FN=
for %%I in (%BOT_PASTE_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Bottom Paste       : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%BOT_PASTE_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BOT_PASTE_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%BOT_PASTE_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Bottom Silkscreen
set FN=
for %%I in (%BOT_SILK_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Bottom Silkscreen  : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%BOT_SILK_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BOT_SILK_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%BOT_SILK_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem Board Outline
set FN=
for %%I in (%BOARD_OUTLINE_FILENAMES%) do (
set FN=%%I
)
if not "%FN%" == "" (
echo: %layernum%	Board Outline      : %FN%
echo:^(define-layer^^! %layernum% ^(cons 'filename "%FN%"^)>> %GVPFILE%
echo:	^(cons 'visible #%BOARD_OUTLINE_VISIBLE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BOARD_OUTLINE_COLOR%^)^)>> %GVPFILE%
echo:	^(cons 'alpha #^(%BOARD_OUTLINE_ALPHA%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%

set /a layernum+=1
)



@rem GVP Project / Background color
echo:^(define-layer^^! -1 ^(cons 'filename %GVPFILE%^)>> %GVPFILE%
echo:	^(cons 'color #^(%BACKGROUND_COLOR%^)^)>> %GVPFILE%
echo:^)>> %GVPFILE%
echo:^(set-render-type^^! 3^)>> %GVPFILE%



@rem END
echo.
set /p X=Press any key to exit . . .<nul
pause > nul
endlocal
