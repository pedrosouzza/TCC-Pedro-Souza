function [A0te_pmethod0, lamte_pmethod0, mte_pmethod0] = Pmethod0_temp(p, ts, A0s, lams, Cs, alps, tt, mt_vec, ms_vec, Ct, alpt, g)

    % Número de temperaturas
    nt = length(ts);

    % Inicializa vetores de saída
    A0te_pmethod0 = zeros(nt, 1);
    lamte_pmethod0 = zeros(nt, 1);
    mte_pmethod0 = zeros(length(p) * nt, 1);

    % Loop sobre cada temperatura para calcular os parâmetros
    for i = 1:nt
        % Seleciona a coluna correspondente de ms_vec e mt_vec
        ms_temp = ms_vec(:, i);
        mt_temp = mt_vec(:, i);

        % Matriz de observação (obtida pela linearização da função de p)
        A = [ones(size(p)), p];

        % Vetor do lado direito
        y1 = (mt_temp + Ct)./(ms_temp + Cs);
        y2 = (1 + alps.*(ts(i) - 20))./(1 + alpt.*(tt(i)-20));
        y = y1.*y2;

        % Solução dos mínimos quadrados b = [AOt/AOs lamt*AOt/A0s]
        b = A\y;

        % Extrai os parâmetros da área efetiva
        A0te_pmethod0(i) = A0s * b(1);
        lamte_pmethod0(i) = lams + b(2)/b(1);

        % Calcula os valores de carga aplicada que são determinados pela equação
        % de pressão e por essas estimativas
        mte_pmethod0((i - 1) * length(p) + 1 : i * length(p)) = mpmass_temp(p, g, A0te_pmethod0(i), A0s, lams, lamte_pmethod0(i), alps, alpt, ts(i), tt, Ct, Cs);
    end
end
