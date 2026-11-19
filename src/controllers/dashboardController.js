var dashboardModel = require("../models/dashboardModel");


function incidenciaMaiorMenor(req, res) {
    dashboardModel.incidenciaMaiorMenor() 
        .then((result) => {
            res.json(result)
        })
}

module.exports = {
  incidenciaMaiorMenor
};
