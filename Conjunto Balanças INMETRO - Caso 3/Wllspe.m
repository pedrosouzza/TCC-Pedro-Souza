% MÉTODO LINEAR DOS MÍNIMOS QUADRADOS

function [A0_wllspe, lambda_wllspe, me_wllspe] = Wllspe(p, t, m, w, C, alpha, g) 

% Função wllspe é definida com os parâmetros de entrada (p, t, m, w, C, alpha, g) 
% e três parâmetros de saída (A0, lambda, me)]%

% Função WLLSPE:
%   É feito a suposição que os valores registrados de pressão e temperatura
%   são exatos e que existe erro nos valores de carga aplicada, ela resolve
%   a equação de pressão utilizando os mínimos quadrados ponderados para
%   determinar os parâmetros de área efetiva para uma balança de pressão

% Parâmetros de entrada:
%   p -->  Valores de pressão (MPa)
%   t --> Valores de temperatura (ºC)
%   m -->  Cargas aplicadas (kg)
%   w --> Ponderação dos valores de carga aplicada (wi invs prop ao erro mi)
%   C,
%   alpha -->   Parâmetros da balança de pressão (verificar PCONST)
%   g -->   Constante gravitacional (m/s^2)

%   Parâmetros de saída:
%   A0,
%   lambda -->  Parâmetro de área efetiva para uma balança de pressão
%   me -->  Cargas aplicadas determinadas pela equação de pressão e por
%   estimativas da área efetiva

% Matriz de observação ponderada (depende dos dados exatos de p e t)

wt = (1 + alpha.*(t - 20)).*w;
A = [wt.*p  wt.*p.*p];

% Vetor ponderado do lado direto (depende dos dados inexatos de m)

y = w.*(m + C).*g;

% Resolve a equação linear e retira os valores nulos da matriz

b = A\y;

% Extrai parâmetros da área efetiva

A0_wllspe = b(1);
lambda_wllspe = b(2)/b(1);

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

me_wllspe = pmass(p, t, A0_wllspe, lambda_wllspe, C, alpha, g);

