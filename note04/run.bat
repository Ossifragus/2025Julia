REM This script runs the Julia simulation for different models and cases.
REM It creates output directories for each model and runs the simulation in parallel.

:: run.bat

@echo off

setlocal enabledelayedexpansion

for %%m in (linear logistic) do (
if not exist "%%m\output" mkdir "%%m\output"
echo model: %%m
set model=%%m

for /L %%i in (1,1,2) do (
echo case: %%i
set case=%%i
start /B julia -t 10 run.jl > "%%m\output\simuCase%%i.out"
timeout /t 1 >nul
)
)


echo All tasks started.
endlocal
