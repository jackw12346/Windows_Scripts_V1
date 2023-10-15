$username = Read-Host -Prompt 'Input your username'

$folderPath = "C:\files"
if (!(Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

$filesUrl = "https://drive.google.com/uc?export=download&id=1P68-lGZZKj16OISrVURcH-NOO861ArSs"
$filesZip = Join-Path -Path $folderPath -ChildPath "files.zip"
Invoke-WebRequest -Uri $filesUrl -OutFile $filesZip

[System.IO.Compression.ZipFile]::ExtractToDirectory($filesZip, $folderPath)

$filesFolderPath = Join-Path -Path $folderPath -ChildPath "files"

$baseline_exe = (Get-Content (Join-Path -Path $filesFolderPath -ChildPath "exe_files.txt")) -split ', '
$baseline_audio = (Get-Content (Join-Path -Path $filesFolderPath -ChildPath "audio_files.txt")) -split ', '
$baseline_video = (Get-Content (Join-Path -Path $filesFolderPath -ChildPath "video_files.txt")) -split ', '
$baseline_script = (Get-Content (Join-Path -Path $filesFolderPath -ChildPath "script_files.txt")) -split ', '
$baseline_txt = (Get-Content (Join-Path -Path $filesFolderPath -ChildPath "txt_files.txt")) -split ', '

$system_exe = Get-ChildItem -Path "C:\" -Filter "*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
$system_audio = Get-ChildItem -Path "C:\" -Filter "*.mp3" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
$system_video = Get-ChildItem -Path "C:\" -Filter "*.mp4" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
$system_script = Get-ChildItem -Path "C:\" -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
$system_txt = Get-ChildItem -Path "C:\" -Filter "*.txt" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName

$extra_exe = $system_exe | Where-Object { $_ -notin $baseline_exe -and $_ -notmatch "C:\\Windows\\WinSxS\\" -and $_ -notmatch "C:\\files\\" -and $_ -notmatch "C:\\Users\\$username\\Desktop\\PSTools\\" }
$extra_audio = $system_audio | Where-Object { $_ -notin $baseline_audio -and $_ -notmatch "C:\\Windows\\WinSxS\\" -and $_ -notmatch "C:\\files\\" -and $_ -notmatch "C:\\Users\\$username\\Desktop\\PSTools\\" }
$extra_video = $system_video | Where-Object { $_ -notin $baseline_video -and $_ -notmatch "C:\\Windows\\WinSxS\\" -and $_ -notmatch "C:\\files\\" -and $_ -notmatch "C:\\Users\\$username\\Desktop\\PSTools\\" }
$extra_script = $system_script | Where-Object { $_ -notin $baseline_script -and $_ -notmatch "C:\\Windows\\WinSxS\\" -and $_ -notmatch "C:\\files\\" -and $_ -notmatch "C:\\Users\\$username\\Desktop\\PSTools\\" }
$extra_txt = $system_txt | Where-Object { $_ -notin $baseline_txt -and $_ -notmatch "C:\\Windows\\WinSxS\\" -and $_ -notmatch "C:\\files\\" -and $_ -notmatch "C:\\Users\\$username\\Desktop\\PSTools\\" }

$folderPath2 = "C:\extra_files"
if (!(Test-Path -Path $folderPath2)) {
    New-Item -ItemType Directory -Path $folderPath2 | Out-Null
}

$extra_exe | Out-File "C:\extra_files\exe_files.txt"
$extra_audio | Out-File "C:\extra_files\audio_files.txt"
$extra_video | Out-File "C:\extra_files\video_files.txt"
$extra_script | Out-File "C:\extra_files\script_files.txt"
$extra_txt | Out-File "C:\extra_files\txt_files.txt"
