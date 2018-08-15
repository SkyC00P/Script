@echo off

call env.cmd
set "_host_path=%cd%"
set "_guset_path=/tmp/"

for /R "%_host_path%" %%i in ( *.sh ) do vmrun -T ws -gu %_gu%  -gp %_gp% CopyFileFromHostToGuest "%_vmx_file%" "%%~fi" "%_guset_path%%%~xni"