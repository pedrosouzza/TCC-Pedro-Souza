% PROGRAMA QUE CHAMA TODAS AS FUNÇÕES

% Chama a função pconst para obter os parâmetros
[A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w, n] = pconst;

% Agora com os valores dos parâmetros, e pode usá-los para chamar a função pmass
m = pmass(p, t, A0original, lambdaoriginal, C, alpha, g);

% Agora com os valores dos parâmetros, e pode usá-los para chamar a função mpmass
[ms,mt] = mpmass(p, g, A0t, A0s, lams, lamt, alps, alpt, ts, tt, Cs, Ct);

% Chama a função Wllspe
[A0_wllspe, lambda_wllspe, me_wllspe] = Wllspe(p, t, m, w, C, alpha, g);

% Chama a função Wllspec
[A0_wllspec, lambda_wllspec, C_wllspec, me_wllspec] = Wllspec(p, t, m, w, alpha, g);

% Chama a função pmethod0
[A0te_pmethod0, lamte_pmethod0, mte_pmethod0] = Pmethod0(p, ts, A0s, lams, Cs, alps, tt, mt, ms, Ct, alpt, g);

% Chama a função pmethod1
[A0te_pmethod1, lamte_pmethod1, mte_pmethod1] = Pmethod1(p, ts, A0s, lams, Cs, alps, tt, mt, ms, Ct, alpt, g);

% Chama a função dpmethod0
[A0te_dpmethod0, lamte_dpmethod0, mte_dpmethod0] = Dpmethod0(p, tt_, mt, Ct, alpt, g);

% Chama a função dpmethod1
[A0te_dpmethod1, lamte_dpmethod1, mte_dpmethod1] = Dpmethod1(p, tt_, mt, Ct, alpt, g);

% Chama a função Dpmethodi para calcular os valores de A0te e lamte para diferentes i0
[A0te_vec, lamte_vec, mte_dpmethodi] = Dpmethodi(p, tt_, mt, Ct, alpt, g);

% Chama a função Uncertainty para calcular os valores das incertezas
% utilizando os valores reais de A0 e lambda
[u_Ap_combinada_values, u_Ap_expandida_values, p_PA] = uncertainty;

% Chama a função Uncertainty para calcular os valores das incertezas
% utilizando os piores valores estimados de A0 e lambda
[u_Ap_combinada_values_modificada, u_Ap_expandida_values_modificada, p_PA_modificada] = uncertainty_modified;

% Criação de vetores
pressoes = p;
metodos = {'Wllspe'; 'Wllspec'; 'pmethod0'; 'pmethod1'; 'dpmethod0'; 'dpmethod1'};
A0_Real = [A0original; A0original; A0t; A0t; A0t; A0t];
A0_Estimado = [A0_wllspe; A0_wllspec; A0te_pmethod0; A0te_pmethod1; A0te_dpmethod0; A0te_dpmethod1];
lambda_Real = [lambdaoriginal; lambdaoriginal; lamt; lamt; lamt; lamt];
lambda_Estimado = [lambda_wllspe; lambda_wllspec; lamte_pmethod0; lamte_pmethod1; lamte_dpmethod0; lamte_dpmethod1];
massas = [m, me_wllspe, me_wllspec, mt, mte_pmethod0, mte_pmethod1, mte_dpmethod0, mte_dpmethod1];
Tamanho = length(p);
A0_Real_Dpmethodi = repmat(A0t, Tamanho, 1);
lamda_Real_Dpmethodi = repmat(lamt, Tamanho, 1);

%---------------------------------------------------------------------------------------------------------------------------------

% Nome da pasta de trabalho no Excel
workbookName = 'Resultados_Conjunto_INMETRO_Caso_3_teste.xlsx';

% Defina os dados que você deseja exportar
PressoesData = table(pressoes, 'VariableNames', {'Range de Pressão (MPa)'});
inputData = table(metodos, A0_Real, A0_Estimado, lambda_Real, lambda_Estimado, 'VariableNames', {'Método', 'Valor A0 Real (mm²)', 'Valor A0 Estimado (mm²)', 'Valor Coef. Distorção Real (1/MPa)', 'Valor Coef. Distorção Estimado (1/MPa)'});
resultsData = table(A0_Real_Dpmethodi , A0te_vec, lamda_Real_Dpmethodi, lamte_vec, 'VariableNames', {'Valor A0 Real (mm²)', 'Valor A0 Estimado (mm²)', 'Valor Coef. Distorção Real (1/MPa)', 'Valor Coef. Distorção Estimado (1/MPa)'});
conjunto_massas_wllspe = table(m, me_wllspe, me_wllspec,'VariableNames', {'Massa da Balança Teste Original (Kg)', 'Massa da Balança Teste - wllspe (Kg)', 'Massa da Balança Teste - wllspec (Kg)'});
conjunto_massas_p_deltap = table(mt, mte_pmethod0, mte_pmethod1, mte_dpmethod0, mte_dpmethod1, mte_dpmethodi, 'VariableNames', {'Massa da Balança Teste Original (Kg)', 'Massa da Balança Teste - pmethod0 (Kg)', 'Massa da Balança Teste - pmethod1 (Kg)', 'Massa da Balança Teste - dpmethod0 (Kg)', 'Massa da Balança Teste - dpmethod1 (Kg)', 'Massa da Balança Teste - dpmethodi (Kg)'});
incertezas = table(p_PA, u_Ap_combinada_values, u_Ap_combinada_values_modificada, u_Ap_expandida_values, u_Ap_expandida_values_modificada, 'VariableNames', {'Faixa de Pressões (Pa)', 'Incerteza Combinada Original (Pa-¹)', 'Incerteza Combinada Modificada (Pa-¹)', 'Incerteza Expandida Original (Pa-¹)', 'Incerteza Expandida Modificada (Pa-¹)'});

% Exporte os dados para a pasta de trabalho no Excel
writetable(PressoesData, workbookName, 'Sheet', 'Range_Pressoes');
writetable(inputData, workbookName, 'Sheet', 'Resultados_Gerais');
writetable(resultsData, workbookName, 'Sheet', 'Resultados_dpmethodi');
writetable(conjunto_massas_wllspe, workbookName, 'Sheet', 'Massas_Mínimo_Quadrado');
writetable(conjunto_massas_p_deltap, workbookName, 'Sheet','Massas_p_deltap');
writetable(incertezas, workbookName, 'Sheet', 'Incertezas');