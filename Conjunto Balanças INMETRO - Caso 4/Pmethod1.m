% MÉTODO-P COM APROXIMAÇÃO

function [A0te_pmethod1, lamte_pmethod1, mte_pmethod1] = Pmethod1(p, ts, A0s, lams, Cs, alps, tt, mt, ms, Ct, alpt, g)

% Função pmethod1:
%   Método-P utilizado para derterminar os parâmetros de área efetiva de
%   uma certa balança de teste, modificado para evitar lineariazações

% Parâmetros de entrada:
%   p -->   Valores de pressão (MPa)
%   ts -->  Valores de temperatura (ºC) para a balança padrão
%   ms -->  Cargas aplicadas (kg) para a balança padrão
%   A0s --> 
%   lams --> Parâmetros da área efetiva para a balança padrão
%   Cs -->
%   alps --> Parâmetros da balança padrão (verificar PCONST)
%   tt --> Valores de temperatura (ºC) para a balança teste
%   mt --> Cargas aplicadas (kg) para a balança teste
%   Ct -->
%   alpt --> parâmetros da balança teste (verificar PCONST)
%   g -->   Constante gravitacional (m/s^2)
%
%   Parâmetros de saída:
%   A0te,
%   lamte -->  Parâmetros de área efetiva para balança teste
%   mte -->  Cargas aplicadas determinadas pela equação de pressão e por
%   estimativas da área efetiva
%
%   Matriz de observação 

A1 = ones(size(p))./(1 + lams.*p);
A2 = p.*A1;
A = [A1  A2];

%   Vetor do lado direito

y1 = (mt + Ct)./(ms + Cs);
y2 = (1 + alps.*(ts - 20))./(1 + alpt.*(tt-20));
y = y1.*y2;

%   solução dos mínimos quadrdados b = [AOt/AOs lamt*AOt/A0s]

b = A\y;

% Extrai os parâmetros da área efetiva

A0te_pmethod1 = A0s*b(1);
lamte_pmethod1 = A0s*b(2)/A0te_pmethod1;

% Calcula os valores de carga aplicada que são determinados pela equação
% de pressão e por essas estimativas

mte_pmethod1 = mpmass(p, g, A0te_pmethod1, A0s, lams, lamte_pmethod1, alps, alpt, ts, tt, Ct, Cs);

