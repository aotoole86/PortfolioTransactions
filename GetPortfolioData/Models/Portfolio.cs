using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData.Models
{
    public class Portfolio
    {
        public string PortfolioName { get; set; }
        public int PortfolioId { get; set; }
        public float TotalMarketValue { get;set;}
        public List<PortfolioHoldings> Holdings { get; set; } = new List<PortfolioHoldings>();

    }
}
