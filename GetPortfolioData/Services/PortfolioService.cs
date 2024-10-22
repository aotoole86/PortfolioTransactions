using GetPortfolioData.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData.Services
{
    public static class PortfolioService
    {
        private static List<PortfolioHoldings> GetPortfolioHoldings(Portfolio portfolio)
        {
            List<PortfolioHoldings> results = new List<PortfolioHoldings>();

            using (SqlConnection sqlConnection = new SqlConnection(Globals._instance.DBConnectionString)){
                sqlConnection.Open();

                string sql = $"SELECT * FROM dbo.vw_PortfolioHoldings WHERE portfolio_id = {portfolio.PortfolioId}";

                using (SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection))
                {
                    var reader = sqlCommand.ExecuteReader();
                    while (reader.Read())
                    {
                        results.Add(new PortfolioHoldings 
                            { 
                                PortfolioId = Int32.Parse(reader["portfolio_id"].ToString()),
                                PortfolioName = reader["portfolio_name"].ToString(),
                                Price = Decimal.Parse(reader["price"].ToString()),
                                SecId = Int32.Parse(reader["sec_id"].ToString()),
                                SecName= reader["sec_name"].ToString(),
                                Shares = Int32.Parse(reader["shares"].ToString()),
                                TargetWeight = float.Parse(reader["target_weight"].ToString()),
                                ActualWeight = float.Parse(reader["actual_weight"].ToString())
                        });
                    }
                }
            }
            
            return results;

        }

        internal static Portfolio GetPortfolio(int portfolioId)
        {
            Portfolio portfolio = new Portfolio();

            using (SqlConnection sqlConnection = new SqlConnection(Globals._instance.DBConnectionString))
            {
                sqlConnection.Open();

                string sql = $"dbo.GetPortfolio";

                using (SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection))
                {
                    sqlCommand.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCommand.Parameters.Add(new SqlParameter { ParameterName = "portfolio_id", SqlDbType = System.Data.SqlDbType.Int, Value = portfolioId });
                    
                    var reader = sqlCommand.ExecuteReader();
                    while (reader.Read())
                    {
                        portfolio.PortfolioId = Int32.Parse(reader["portfolio_id"].ToString());
                        portfolio.PortfolioName = reader["portfolio_name"].ToString();
                        portfolio.TotalMarketValue = float.Parse(reader["TotalMktVal"].ToString());

                    }
                }
            }

            portfolio.Holdings = GetPortfolioHoldings(portfolio); 

            return portfolio;
        }
        internal static List<Transaction> GetPortfolioBuys(Portfolio portfolio)
        {
            List<Transaction> buys = new List<Transaction>();

            var buyCandidates = portfolio.Holdings.Where(h=>h.ActualWeight < h.TargetWeight).ToList();
            
            foreach (var b in buyCandidates)
            {
                var numberOfUnitsToBuy = (int)(((b.TargetWeight/100 * portfolio.TotalMarketValue) / (float)b.Price) - b.Shares);
                buys.Add(new Transaction { PortfolioId = portfolio.PortfolioId, SecId = b.SecId, TradeDate = DateTime.Today, TransactionType = "BUY", Units = numberOfUnitsToBuy });
                
            }

            return buys;

        }

        internal static List<Transaction> GetPortfolioSells(Portfolio portfolio)
        {
            List<Transaction> sells = new List<Transaction>();

            var sellCandidates = portfolio.Holdings.Where(h => h.ActualWeight > h.TargetWeight).ToList();

            foreach (var b in sellCandidates)
            {
                var numberOfUnitsToSell= (int)(b.Shares - ((b.TargetWeight/100 * portfolio.TotalMarketValue) / (float)b.Price));
                sells.Add(new Transaction { PortfolioId = portfolio.PortfolioId, SecId = b.SecId, TradeDate = DateTime.Today, TransactionType = "BUY", Units = numberOfUnitsToSell});

            }

            return sells;
        }
    }
}
