using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData.Models
{
    internal class Transaction
    {
        public int SecId { get; set; }
        public int PortfolioId { get; set; }   
        public DateTime TradeDate { get; set; }
        public string TransactionType { get; set; }
        
        public int Units { get; set; }
    }
}
