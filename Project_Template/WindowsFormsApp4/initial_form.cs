using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApp4
{
    public partial class initial_form : Form
    {
        public static string unsolved_file = "Boards/diff_1_1_solved.txt";
        public initial_form()
        {
            InitializeComponent();
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            Form1 f = new Form1(false);
            f.Show();
            
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            Form1 f = new Form1(true);
            f.Show();
        }
    }
}
