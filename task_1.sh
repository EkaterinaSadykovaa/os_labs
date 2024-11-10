#!/bin/bash


# Функция для обработки пользователей 
function users() { 
 getent passwd | awk -F: '{print $1, $6}' | sort 
} 
 
# Функция для обработки процессов 
function processes() { 
 ps -eo pid,comm --sort=pid 
}

# Функция для вывода справки 
function h_help() { 
 echo "Использование: $0 [OPTIONS]" 
 echo "Опции:" 
 echo "  -u, --users        Вывести список пользователей и их домашних директорий." 
 echo "  -p, --processes    Вывести список запущенных процессов." 
 echo "  -h, --help         Показать это сообщение." 
 echo "  -l PATH, --log PATH    Выводить результаты в указанный файл." 
 echo "  -e PATH, --errors PATH  Выводить ошибки в указанный файл." 
 exit 0 
} 


# Функция проверки доступности пути и создание файла, если необходимо 
check_and_create_file() { 
 local path="$1" 
 if [[ ! -d "$(dirname "$path")" ]]; then 
  echo "Ошибка: Директория '$path' не существует." >&2 
  exit 1 
 fi 
 
 if [[ -f "$path" ]]; then 
  echo "Предупреждение: Файл '$path' существует. Будет перезаписан." >&2 
 fi 
 touch "$path" # создаем файл если он не существует. 
 # проверяем права на запись 
 if [[ ! -w "$path" ]]; then 
  echo "Ошибка: Нет прав на запись в '$path'" >&2 
  exit 1 
 fi 
 
} 

# Функция перенаправления стандартного вывода 
redirect_stdout() { 
  local log_file="$1" 
  check_and_create_file "$log_file" 
  exec > "$log_file" 
} 
 
# Функция перенаправления стандартного потока ошибок 
redirect_stderr() { 
  local error_file="$1" 
  check_and_create_file "$error_file" 
  exec 2>"$error_file" 
} 



 
while getopts ":uphl:e:" opt; do
 case $opt in
 u)
  users
  ;;
 p)
  processes
  ;;
 h)
  h_help
  ;;

 l)
  log_file="$OPTARG" 
  redirect_stdout "$log_file"  
  ;;
 e)
  error_file="$OPTARG" 
  redirect_stderr "$error_file" 
  ;;

 ?)
  echo "Ошибка: Неизвестный параметр -$OPTARG" >&2 
  exit 1
  ;;
         
 :)
  echo "Ошибка: Параметру -$OPTARG не хватает значения." >&2 
  exit 1
  ;;
 esac
done

 
# Пример использования 
 
echo "1  Hi! - сообщения из скрипта будут перенаправляться в этот файл" 
#echo "1  Error - ошибки из скрипта будут перенаправляться в этот файл" >&2 
 ls %
 # ls % - выдаёт ошибку и напраяляет её в поток ошибок
 
exit 0
