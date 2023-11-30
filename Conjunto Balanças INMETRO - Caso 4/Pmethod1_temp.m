function [A0te_pmethod1_vec, lamte_pmethod1_vec, mte_pmethod1] = Pmethod1_temp(p, ts, A0s, lams, Cs, alps, tt, mt_vec, ms_vec, Ct, alpt, g)
    % Número de temperaturas
    nt = length(ts);

    % Inicializa vetores de saída
    A0te_pmethod1_vec = zeros(nt, 1);
    lamte_pmethod1_vec = zeros(nt, 1);
    mte_pmethod1 = zeros(length(p) * nt, 1);

    % Loop sobre cada temperatura para calcular os parâmetros
    for i = 1:nt
        % Seleciona a coluna correspondente de ms_vec e mt_vec
        ms_temp = ms_vec(:, i);
        mt_temp = mt_vec(:, i);

        % Matriz de observação (depende dos dados exatos de p e t)
        A1 = ones(size(p))./(1 + lams.*p);
        A2 = p.*A1;
        A = [A1  A2];

        % Vetor ponderado do lado direito (depende dos dados inexatos de m)
        y1 = (mt_temp + Ct)./(ms_temp + Cs);
        y2 = (1 + alps.*(ts(i) - 20))./(1 + alpt.*(tt(i)-20));

        y = y1.*y2;

        % Resolve a equação linear e retira os valores nulos da matriz
        b = A \ y;

        % Extrai os parâmetros da área efetiva
        A0te_pmethod1_vec(i) = A0s * b(1);
        lamte_pmethod1_vec(i) = A0s * b(2) / A0te_pmethod1_vec(i);

        % Calcula os valores de carga aplicada que são determinados pela equação
        % de pressão e por essas estimativas
        mte_pmethod1((i - 1) * length(p) + 1 : i * length(p)) = mpmass(p, g, A0te_pmethod1_vec(i), A0s, lams, lamte_pmethod1_vec(i), alps, alpt, ts(i), tt(i), Ct, Cs);  % Modificação aqui
    end
end
