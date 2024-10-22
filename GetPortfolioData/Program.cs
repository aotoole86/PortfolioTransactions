using GetPortfolioData.Services;
using System;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Globals._instance.DBConnectionString = ConfigurationManager.AppSettings["DBConnectionString"];

            Console.WriteLine("Please enter a portfolio number");

            string portfolioId = Console.ReadLine();
            
            var portfolio = PortfolioService.GetPortfolio(int.Parse(portfolioId));
            var buys = PortfolioService.GetPortfolioBuys(portfolio);
            var sells = PortfolioService.GetPortfolioSells(portfolio);


            foreach (var b in buys)
            {
                Console.WriteLine($"Portfolio: {portfolio.PortfolioName} TransationType='BUY', SecId: {b.SecId}, Units: {b.Units}");
            }
            foreach (var b in sells)
            {
                Console.WriteLine($"Portfolio: {portfolio.PortfolioName} TransationType='SELL', SecId: {b.SecId}, Units: {b.Units}");
            }


            Console.ReadLine();
        }
    }
}
