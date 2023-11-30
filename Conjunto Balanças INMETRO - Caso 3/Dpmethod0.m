 % MÉTODO-DELTAP SEM UTILIZAR C

function [A0te_dpmethod0, lamte_dpmethod0, mte_dpmethod0] = Dpmethod0(p, tt_, mt, Ct, alpt, g)

% Função dpmethod0:
%   Método-DeltaP utilizado para derterminar os parâmetros de área efetiva de
%   uma certa balança de teste.

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

%   Matriz de observação 

ps = p(1) + p(2:mp);
A = [ones(size(ps, 1), 1), ps];

%   Vetor do lado direito

dm = mt(2:mp) - mt(1);
dp = p(2:mp) - p(1);
y1 = dm.*g./(1 + alpt.*(tt_(2:mp) - 20));
y2 = dp - alpt.*(tt_(1) - tt_(2:mp)).*p(1);
y = y1./y2;

%   solução dos mínimos quadrdados

b = A\y;

% Extrai os parâmetros da área efetiva

A0te_dpmethod0 = b(1);
lamte_dpmethod0 = b(2)/b(1);

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

mte_dpmethod0 = pmass(p, tt_, A0te_dpmethod0, lamte_dpmethod0, Ct, alpt, g);