% MÉTODO-DELTAP UTILIZANDO C E COM APROMIXAÇÃO

function [A0te_dpmethod1, lamte_dpmethod1, mte_dpmethod1] = Dpmethod1(p, tt_, mt, Ct, alpt, g)

% Função dpmethod1:
%   Simulação do Método-DeltaP utilizado para derterminar os parâmetros de área efetiva de
%   uma certa balança de teste, resolvendo um problema de mínimos quadrados
%   ponderados derivado da equação de pressão. O termo de correção Ct é
%   eliminando implicitamente usando informações derivdas da 1ª medição

% Parâmetros de entrada:
%   p -->   Valores de pressão (MPa)
%   tt --> Valores de temperatura (ºC) para a balança teste
%   mt --> Cargas aplicadas (kg) para a balança teste
%   Ct -->
%   alpt --> parâmetros da balança teste (verificar PCONST)
%   g -->   Constante gravitacional (m/s^2)

%   Parâmetros de saída:
%   A0te,
%   lamte -->  Parâmetros de área efetiva para balança teste
%   mte -->  Cargas aplicadas determinadas pela equação de pressão e por
%   estimativas da área efetiva

%   Número de medidas

mp = length(p);

%   Matriz de observação ponderado

dp = p(2:mp) - p(1);
sp = p(2:mp) + p(1);
w = 1./dp;
A = [w.*dp  w.*dp.*sp];

%   Vetor ponderado do lado direito

y1 = (mt(2:mp) + Ct)./(1 + alpt.*(tt_(2:mp) - 20));
y2 = (mt(1) + Ct)./(1 + alpt.*(tt_(1) - 20));
y = w.*(y1 - y2).*g;

%   solução dos mínimos quadrdados

b = A\y;

% Extrai os parâmetros da área efetiva

A0te_dpmethod1 = b(1);
lamte_dpmethod1 = b(2)/b(1);

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

mte_dpmethod1 = pmass(p, tt_, A0te_dpmethod1, lamte_dpmethod1, Ct, alpt, g);