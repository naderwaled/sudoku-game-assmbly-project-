using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;
namespace WindowsFormsApp4
{
    static class Program
    {

        public static TextBox[] txt = new TextBox[82];


       
        [DllImport("Project.dll")]
        public static extern int WriteTo_File(int[] arraytowrite, string filename);

        [DllImport("Project.dll")]
        public static extern int Edit_cmp(int position, int value);

        [DllImport("Project.dll")]
        public static extern int Return_last_game();

        [DllImport("Project.dll")]
        public static extern void clear_board([In,Out] int[] clearBoard);

        [DllImport("Project.dll")]
        public static extern void print_solved_board([In,Out] int [] solvedBoard);

        [DllImport("Project.dll")]
        public static extern int return_wrong();

        [DllImport("Project.dll")]
        public static extern int return_correct();

        [DllImport("Project.dll")]
        public static extern int Save_to_file(int[] array, string fName);
        [DllImport("Project.dll")]
        public static extern int Save_Rank(string Time, string pName, int wronganswers);

        [DllImport("Project.dll")]
        public static extern void newgame(int level, int[] Cuser_board);

        [DllImport("Project.dll")]
        public static extern int Continue([Out] int[] arrayOffset);

        [DllImport("Project.dll")]
        public static extern int get_Board(int level, [Out] int[] arrayOffset);
        [DllImport("Project.dll")]
        public static extern int helper ();

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new initial_form());
        }
    }
}
