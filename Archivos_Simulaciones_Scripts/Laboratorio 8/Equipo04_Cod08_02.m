%% example_correlation.m
%   Script de ejemplo que calcula la función de autocorrelación de una
%   secuencia PN. El script también demuestra el uso de la función "xcorr"
%   de MATLAB para correlacionar una señal recibida con una secuencia PN.
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

close all
clear all

% Especificar código PN
code = [-1 1 -1 1 1 1 -1 1 1 -1 -1 -1 1 1 1 1]';
M = length(code);

% Calcular la función de autocorrelación
% R[k] = 1/M sum_{n=1}^{M} c[n] c[n-k]
% Nota: Se usa "circshift" porque se asume que la secuencia es periódica
R = zeros(M,1);
k = 0:1:(M-1);
for ii=1:length(k)
    R(ii) = 1/M * (code' * circshift(code,k(ii))); % circshift
end
stem(k,R)

% Simular datos DSSS recibidos y usar "xcorr" para correlacionarlos con el código PN
% Se asume un factor de dispersión de M
m = [1 1 -1 1]';
g = [m(1)*code; m(2)*code; m(3)*code; m(4)*code]; 

[r,lag] = xcorr(g,code);
figure
stem(lag,r)




