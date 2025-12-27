Mark of the Web Service Utility

This utility is designed for batch processing of Internet security labels (MotW) and is written in PowerShell. It runs on systems starting from Windows 10.

mws [Folder Path] [-r,-d,-b,-f,-z,-i,-s,-m]

If you don't specify a folder to process, the default is the folder from which this utility was launched.

Running without additional parameters only displays all files with a blocked status.

-r
Recursively scans all subfolders in the specified directory. Recursion is disabled by default; in this case, only the root folder will be scanned, excluding subfolders.

-d
Deletes security labels from locked files

-b
Blocking files by setting security labels

-f
Forced mode. If launched with the -d switch, only files in the specified lock zone will be unlocked, if any. If not, nothing will happen. If launched with the -b switch, only locked files that do not belong to the specified zone will be locked. If the lock zone matches the specified zone, such files will be ignored, as will files that are not locked. If launched without the -d and -b switches, only locked files will be displayed.

-z
Zone, from 0 to 4, default 3 (Internet)

-i
Interlaced lines in a different color when outputting to the screen for better readability.

-s
Sorting the output. If used with the -d or -b switches, only processed files are output, not all files. If launched without these parameters, only blocked files with a specific zone are output.

-m
Mask for searching files according to the specified pattern, for example: -m *.txt or -m *read* , etc. Standard system masks are used. If the pattern contains spaces, double quotes must be used.

RUS

Данная утилита предназначена для пакетной обработки меток безопасности интернета (MotW) и написана на powershell, работает на системах начиная с Windows 10.

mws [Путь к папке] [-r,-d,-b,-f,-z,-i,-s,-m]

Если не указывать обрабатываемую папку, то по умолчанию будет подразумеваться та папка из которой был произведён запуск данной утилиты.

Запуск без дополнительных параметров осуществляет только вывод на экран всех файлов со статусом блокировки файлов.

-r
Рекурсивно сканирует все вложенные папки в указанной директории, по умолчанию рекурсия отключена, в этом случае будет сканироваться только корень папки, исключая вложенные.

-d 
Удаление метки безопасности у заблокированных файлов

-b 
Блокировка файлов путём установки метки безопасности у незаблокированных файлов

-f
Форсированный режим, если запуск произошёл с ключом -d то тогда будет происходить разблокировка только файлов с указаной зоной блокировки, если они есть, если же их нет то ничего происходить не будет. Если запуск произошёл с ключом -b, то тогда будет происходить блокировка только заблокированных файлов которые не принадлежат указанной зоне, а если зона блокировки совпадает с указанной зоной, то тогда такие файлы будут проигнорированы, также будут и проигнорированы файлы которые не заблокированы. Если запуск произошёл без ключей -d и -b, то тогда будут выведены на экран только заблокированные файлы.

-z 
Зона блокировки, от 0 до 4, по умолчанию 3 (Интернет)

-i
Чересстрочная окраска строк другим цветом при выводе на экран для лучшей читаемости  

-s
Сортировка вывода на экран, если используется с ключами -d или -b то тогда происходит вывод только обработанных файлов, а не всех, если без этих параметров произошел запуск, то тогда происходит вывод на экран только заблокированных файлов с определённой зоной.

-m
Маска для поиска файлов по указанному шаблону, например: -m *.txt или -m *read* и т.д. используются стандартные системные маски, если в шаблоне есть пробелы, то тогда нужно использовать двойные кавычки.

2025 Andrey Karpov
