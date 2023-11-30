function [ms_vec, mt_vec] = mpmass_temp(p, g, A0t, A0s, lams, lamt, alps, alpt, ts, tt, Cs, Ct)
    % Função mpmass_temp modificada para armazenar valores em vetores para cada coluna

    % Número de medições
    n = length(p);

    % Número de temperaturas para a balança padrão e de teste
    num_temps = length(ts);

    % Inicializa vetores de cargas aplicadas
    ms_vec = zeros(n, num_temps);
    mt_vec = zeros(n, num_temps);

    % Loop sobre cada temperatura
    for i = 1:num_temps
        % Cálculo das cargas aplicadas para a temperatura da balança padrão
        ms_vec(:, i) = (A0s / g) * (p .* (1 + lams * p) .* (1 + alps * (ts(i) - 20))) - Cs;

        % Cálculo das cargas aplicadas para a temperatura da balança de teste
        mt_vec(:, i) = (A0t / g) * (p .* (1 + lamt * p) .* (1 + alpt * (tt(i) - 20))) - Ct;
    end
end
