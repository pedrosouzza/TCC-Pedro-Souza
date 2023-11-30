% MÉTODO LINEAR DOS MÍNIMOS QUADRADOS COM C DESCONHECIDO

function [A0_wllspec, lambda_wllspec, C_wllspec, me_wllspec] = Wllspec(p, t, m, w, alpha, g) 

% Função wllspe é definida com os parâmetros de entrada (p, t, m, w, alpha, g) 
% e três parâmetros de saída (A0, lambda, C, me)

% Função WLLSPE:
%   É feito a suposição que os valores registrados de pressão e temperatura
%   são exatos e que existe erro nos valores de carga aplicada, ela resolve
%   a equação de pressão utilizando os mínimos quadrados ponderados para
%   determinar os parâmetros de área efetiva para uma balança de pressão,
%   também fazendo uma estimativa de correção do termo C para as cargas
%   aplicadas da balança

% Parâmetros de entrada:
%   p -->   Valores de pressão (MPa)
%   t -->   Valores de temperatura (ºC)
%   m -->   Cargas aplicadas (kg)
%   w -->   Ponderação dos valores de carga aplicada (wi invs prop ao erro mi)
%   alpha -->  Parâmetros da balança de pressão (verificar PCONST) usado para
%   correção da temperatura
%   g -->   Constante gravitacional (m/s^2)
%
%   Parâmetros de saída:
%   A0,
%   lambda -->  Parâmetro de área efetiva para uma balança de pressão
%   C -->   Estimativa de correção das cargas aplicadas para a balança
%   me -->  Cargas aplicadas determinadas pela equação de pressão e por
%   estimativas da área efetiva
%
%   Matriz de observação ponderada (depende dos dados exatos de p e t)

wt = (1 + alpha.*(t - 20)).*w;
A = [wt.*p, wt.*p.*p, -w.*ones(size(p)).*g];

% Vetor ponderado do lado direto (depende dos dados inexatos de m)

y = w.*m.*g;

% Resolve para os parâmetros b = [A0  A0*lambda]

b = A\y;

% Extrai parâmetros da área efetiva

A0_wllspec = b(1);
lambda_wllspec = b(2)/b(1);
C_wllspec = b(3);

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

me_wllspec = pmass(p, t, A0_wllspec, lambda_wllspec, C_wllspec, alpha, g);
