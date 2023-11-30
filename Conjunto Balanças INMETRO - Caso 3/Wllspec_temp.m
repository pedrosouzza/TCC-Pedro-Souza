function [A0_wllspec_vec, lambda_wllspec_vec, C_wllspec_vec, me_wllspec] = Wllspec_temp(p, t, m_vec, w, alpha, g)
    % Função WLLSPEC modificada para aceitar m_vec e iterar sobre as colunas

    % Número de temperaturas
    num_temperaturas = length(t);

    % Inicializa vetores de parâmetros
    A0_wllspec_vec = zeros(num_temperaturas, 1);
    lambda_wllspec_vec = zeros(num_temperaturas, 1);
    C_wllspec_vec = zeros(num_temperaturas, 1);
    me_wllspec = zeros(length(p) * num_temperaturas, 1);

    % Loop sobre cada temperatura
    for i = 1:num_temperaturas
        % Seleciona a coluna correspondente de m_vec
        m = m_vec(:, i);

        % Matriz de observação ponderada (depende dos dados exatos de p e t)
        wt = (1 + alpha.*(t(i) - 20)).*w;
        A = [wt.*p, wt.*p.*p, -w.*ones(size(p)).*g];

        % Vetor ponderado do lado direito (depende dos dados inexatos de m)
        y = w.*m.*g;

        % Resolve a equação linear e retira os valores nulos da matriz
        b = A\y;

        % Extrai parâmetros da área efetiva e correção C
        A0_wllspec_vec(i) = b(1);
        lambda_wllspec_vec(i) = b(2)/b(1);
        C_wllspec_vec(i) = b(3);

        % Calcula os valores de carga aplicada que são determinados pela equação
        % de pressão e por essas estimativas
        me_wllspec((i - 1) * length(p) + 1 : i * length(p)) = pmass(p, t(i), A0_wllspec_vec(i), lambda_wllspec_vec(i), C_wllspec_vec(i), alpha, g);
    end
end
