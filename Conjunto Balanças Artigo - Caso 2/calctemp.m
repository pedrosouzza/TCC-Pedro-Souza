%Calcula os parâmetros de A0 e lambda para uma certa variação de
%temperatura (18ºC a 28ºC)

% Chama a função pconst_temp
[A0s, lams, Cs, alps, A0t, A0original, lamt, Ct, alpt, g, p, t, ts, tt, tt_, alpha, C, lambdaoriginal, w, n] = pconst_temp;

% Chama a função mpmass_temp
[ms_vec, mt_vec] = mpmass_temp(p, g, A0t, A0s, lams, lamt, alps, alpt, ts, tt, Cs, Ct);

% Chama a função pmethod0_temp
[A0te_pmethod0, lamte_pmethod0, mte_pmethod0] = Pmethod0_temp(p, ts, A0s, lams, Cs, alps, tt, mt_vec, ms_vec, Ct, alpt, g);

% Criação de vetores
metodo2 = repmat('Pmethod0', length(t),1);

% Nome da pasta de trabalho no Excel
workbookName = 'Avaliação Temperatura - Complemento.xlsx';

% Defina os dados que você deseja exportar
Valores2 = table(metodo2, t, A0te_pmethod0, lamte_pmethod0, 'VariableNames', {'Método', 'Temperatura (ºC)','A0 (mm²)', 'Coef. Distorção (1/MPa)'});

% Exporte os dados para a pasta de trabalho no Excel
writetable(Valores2, workbookName, 'Sheet', 'Pmethod0');