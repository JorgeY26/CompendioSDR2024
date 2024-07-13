%% generateMessage.m
%   Generación de una secuencia de bits para transmitir texto ASCII con SDR
%   Autor: Cory J. Prust, Ph.D.

%% UNIVERSIDAD TÉCNICA DEL NORTE
% Carrera de Ingeniería en Telecomunicaciones
% Radio definida por software
% Laboratorios 8 - 9
% Técnico de laboratorio: Msc. Alejandra Pinto
% Equipo N°4
% Integrantes: Grijalva Ana, Quishpe Evelyn, Yacelga Jorge
% Fecha: 16 de junio de 2024

%% Desarrollo
clear all;
close all;

% Creación del mensaje
a = dec2bin('UTN Universidad\n',8);   % Conversión de ASCII a Binario
numChars = size(a,1);                 % Conteo de caractéres
fprintf(char(bin2dec(a)));            % Impresión del mensaje convertido

% Conversión de cadenas binarias a vectores
a = a - '0';

% Reestructuración en un vector de bits (8 bits por caracter)
a = reshape(a.',8*numChars,1)';

% Verificación de la recuperación de la cadena de bits
b = reshape(a, 8, numChars).';   % Transforma el vector de bits "a" de vuelta a una matriz de 8 columnas.
b = num2str(b);                  % Convierte los valores numéricos a una matriz de caracteres.
fprintf(char(bin2dec(b)));       % Impresión del mensaje original.

% Construcción del paquete de transmisión
pre = [0 0 0 0 1 1 1 1 0 0 0 0 1 1 1 1];   % Prefijo de sincronización
message = [pre a];                         % Concatenación del prefijo y el mensaje
numSymsTot = length(message);              % Cálculo del número total de símbolos
