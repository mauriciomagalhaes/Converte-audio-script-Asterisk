#!/bin/bash
echo -e "\033[1;37maudio2voip\033[1;0m v1.0 - by Ernani Azevedo <azevedo@intellinews.com.br>"
echo
# Verifica se foi informado um parâmetro:
if [ "$#" != 1 ]; then
  echo "Erro: Você deve informar um arquivo no formato WAV ou MP3 (extensão \"wav\" ou \"mp3\")!"
  exit 1
fi
# Verifica se o arquivo informado é formato WAV ou MP3:
if [ "${1##*.}" != "wav" -a "${1##*.}" != "mp3" ]; then
  echo "Erro: Você deve informar um arquivo no formato WAV ou MP3 (extensão \"wav\" ou \"mp3\")!"
  exit 1
fi
# Verifica se arquivo informado existe e é acessível:
if [ ! -f "${1}" ]; then
  echo "Erro: Não foi possível acessar o arquivo \"${1}\"!"
  exit 1
fi
echo "Convertendo \"${1}\" para formatos VoIP"
if [ "${1##*.}" = "mp3" ]; then
  echo -n -e "${1} -> ${1/.mp3/.wav} "
  lame --decode "${1}" "${1/.mp3/.wav}" 1>/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Erro!"
    exit 2
  fi
  echo "OK"
fi
echo -n -e "${1/.mp3/.wav} -> ${1/.mp3/.ulaw} "
sox -V "${1/.mp3/.wav}" -r 8000 -c 1 -t ul "${1/.mp3/.ulaw}" 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Erro!"
  exit 2
fi
echo "OK"
echo -n -e "${1/.mp3/.wav} -> ${1/.mp3/.alaw} "
sox -V "${1/.mp3/.wav}" -r 8000 -c 1 -t al "${1/.mp3/.alaw}" 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Erro!"
  exit 2
fi
echo "OK"
echo -n -e "${1/.mp3/.wav} -> ${1/.mp3/.gsm} "
sox -V "${1/.mp3/.wav}" -r 8000 -c 1 -t gsm "${1/.mp3/.gsm}" 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Erro!"
  exit 2
fi
echo "OK"
echo
echo "Concluído!"
