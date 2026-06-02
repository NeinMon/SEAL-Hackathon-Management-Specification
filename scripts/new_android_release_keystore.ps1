param(
  [string]$Alias = "seal-release",
  [string]$StoreFile = "android\seal-release.jks",
  [int]$ValidityDays = 10000,
  [string]$StorePassword = $env:ANDROID_RELEASE_STORE_PASSWORD,
  [string]$KeyPassword = $env:ANDROID_RELEASE_KEY_PASSWORD,
  [switch]$GeneratePassword
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command keytool -ErrorAction SilentlyContinue)) {
  throw "keytool was not found. Use Android Studio JBR/bin/keytool or install a JDK."
}

$resolvedStore = Join-Path (Resolve-Path .).Path $StoreFile
if (Test-Path $resolvedStore) {
  throw "Keystore already exists at $resolvedStore. Move it first if you want to create a new one."
}

function New-ReleasePassword {
  $bytes = New-Object byte[] 24
  $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
  try {
    $rng.GetBytes($bytes)
  } finally {
    $rng.Dispose()
  }
  return [Convert]::ToBase64String($bytes).TrimEnd("=")
}

if ($GeneratePassword) {
  if (-not $StorePassword) {
    $StorePassword = New-ReleasePassword
  }
  if (-not $KeyPassword) {
    $KeyPassword = New-ReleasePassword
  }
}

if (-not $StorePassword) {
  $secureStore = Read-Host "Release store password" -AsSecureString
  $StorePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStore)
  )
}

if (-not $KeyPassword) {
  $secureKey = Read-Host "Release key password" -AsSecureString
  $KeyPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
  )
}

if ($KeyPassword -ne $StorePassword) {
  Write-Warning "PKCS12 keystores use the store password for key entries. keyPassword will be set to storePassword."
  $KeyPassword = $StorePassword
}

New-Item -ItemType Directory -Force -Path (Split-Path $resolvedStore) | Out-Null

keytool -genkeypair `
  -v `
  -keystore $resolvedStore `
  -storepass $StorePassword `
  -keypass $KeyPassword `
  -keyalg RSA `
  -keysize 2048 `
  -validity $ValidityDays `
  -alias $Alias `
  -dname "CN=SEAL Hackathon, OU=Mobile, O=SEAL, L=Ho Chi Minh City, ST=HCMC, C=VN"

$keyPropertiesPath = Join-Path (Resolve-Path .).Path "android\key.properties"
@"
storePassword=$StorePassword
keyPassword=$KeyPassword
keyAlias=$Alias
storeFile=../seal-release.jks
"@ | Set-Content -LiteralPath $keyPropertiesPath -NoNewline

Write-Output "Release keystore created at $resolvedStore"
Write-Output "Signing config written to $keyPropertiesPath"
Write-Output "Do not commit android/key.properties or the .jks file."
