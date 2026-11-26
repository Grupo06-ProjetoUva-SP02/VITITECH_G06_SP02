var database = require("../database/config");

function incidenciaMaiorMenor() {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");
    var instrucaoSql = `
    SELECT 
        CASE WEEKDAY(data_horario)
            WHEN 0 THEN 'Segunda-feira'
            WHEN 1 THEN 'Terça-feira'
            WHEN 2 THEN 'Quarta-feira'
            WHEN 3 THEN 'Quinta-feira'
            WHEN 4 THEN 'Sexta-feira'
            WHEN 5 THEN 'Sábado'
            WHEN 6 THEN 'Domingo'
        END AS dia_semana,
        MIN(umidade) AS umidade_minima,
        MAX(umidade) AS umidade_maxima
    FROM medida
    WHERE data_horario >= CURDATE() - INTERVAL 7 DAY
    GROUP BY WEEKDAY(data_horario), dia_semana
    ORDER BY WEEKDAY(data_horario);
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function KpiAlerta(idEmpresaVincular) {
    console.log("ACESSEI O AVISO  MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function listar()");

    var instrucaoSql = `
    SELECT
    e.idEmpresa,
    e.razao_social,

        COUNT(
            CASE
                WHEN DATE(m.data_horario) = CURDATE()
                AND m.nivel_alerta >= 2
                THEN m.idMedida
            END
        ) AS alertas_hoje,

        COUNT(
            CASE
                WHEN DATE(m.data_horario) = CURDATE() - INTERVAL 1 DAY
                AND m.nivel_alerta >= 2
                THEN m.idMedida
            END
        ) AS alertas_ontem,

        COUNT(
            CASE
                WHEN DATE(m.data_horario) = CURDATE()
                AND m.nivel_alerta >= 2
                THEN m.idMedida
            END
        ) -
        COUNT(
            CASE
                WHEN DATE(m.data_horario) = CURDATE() - INTERVAL 1 DAY
                AND m.nivel_alerta >= 2
                THEN m.idMedida
            END
        ) AS diferenca_alertas

    FROM empresa AS e

    LEFT JOIN propriedade AS p
        ON p.fk_empresa = e.idEmpresa

    LEFT JOIN baia AS b
        ON b.fk_propriedade = p.idPropriedade

    LEFT JOIN sensor AS s
        ON s.fk_baia = b.idBaia

    LEFT JOIN medida AS m
        ON m.fk_sensor = s.idSensor

    WHERE e.idEmpresa = ${idEmpresaVincular}


    GROUP BY e.idEmpresa, e.razao_social;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    incidenciaMaiorMenor,
    KpiAlerta
}
