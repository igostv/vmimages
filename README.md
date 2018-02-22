## Образа Windows для сборки 1С

содержит образа для сборки 1С

### Windows 10

* базовый - Windows 10 c установленным chocolatey

### Запуск сборки

```powershell
packer.exe build -var "V8VERSION=8.3.5.1570" -var "V8USER=username" -var "V8PASSW=password" .\win10\win10-base.json
```