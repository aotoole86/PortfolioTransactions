using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetPortfolioData
{
    internal class Globals
    {
        private static Globals instance;
        private string _DBConnectionString;
        
        public string DBConnectionString {  
            get { return _DBConnectionString; }
            set {  _DBConnectionString = value; } 
        } 
        public static Globals _instance {
            get { 
                if (instance == null)
                {
                    instance = new Globals();
                }
                return instance;
            }
        }
        private Globals()
        {
        }

    }
}
