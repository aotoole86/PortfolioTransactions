using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData.Models
{
    public class PortfolioHoldings
    {
        public int PortfolioId { get; set; }
        public string PortfolioName { get; set; }
        public DateTime ValueDate { get; set; }
        public int SecId { get; set; }
        public string SecName { get; set; } 
        public int Shares { get; set; }
        public decimal Price { get; set; }
        public float ActualWeight { get; set; }
        public float TargetWeight { get; set; }
    }
}
