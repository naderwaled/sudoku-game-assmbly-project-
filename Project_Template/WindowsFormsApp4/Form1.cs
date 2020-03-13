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
    public partial class Form1 : Form
    {
        int[] user_arr = new int[81];
        int counter = 0;
        int correct=0;
        int wrong=0;
        public Form1(bool continue1)
        {
            InitializeComponent();
            int count = 1;
            double y = 13;
            for (int i = 1; i <= 9; i++)
            {

                int x = 13;
                for (int j = 1; j <= 9; j++)
                {
                    Program.txt[count] = new TextBox();
                    Program.txt[count].ForeColor = Color.Blue;
                    Program.txt[count].Size = new Size(40, 45);
                    Program.txt[count].Location = new Point(x, (int)y);
                    Program.txt[count].Multiline = true;
                    Program.txt[count].BorderStyle = BorderStyle.None;
                    Program.txt[count].Font = new Font("Bold", 16);
                    Program.txt[count].TextAlign = HorizontalAlignment.Center;
                    Program.txt[count].Name = count.ToString();
                    this.Visible = true;
                    pictureBox1.Controls.Add(Program.txt[count]);
                    Program.txt[count].TextChanged += new EventHandler(eventt);

                    if (j % 3 == 0)
                        x += 7;
                    x += 55;
                    count++;
                }
                y += 65;
            }
            if (continue1 == true)
            {
                comboBox1.Visible = false;
                int[] arr = new int[81];
                Program.Continue(arr);
                for (int i = 0; i < 81; i++)
                {
                    if (arr[i] != 0)
                    {
                        Program.txt[i + 1].Text = arr[i].ToString();
                        Program.txt[i + 1].Enabled = false;
                    }
                    else
                    {
                        Program.txt[i + 1].Text = null;
                        Program.txt[i + 1].Enabled = true;
                    }

                }

            }
           
        }
        
        void eventt(object sender, EventArgs e)
        {
            try
            {
                TextBox t = (sender) as TextBox;
                int count = int.Parse(t.Name);
                if (t.Text != "")
                {
                    int check = Program.Edit_cmp(count, int.Parse(Program.txt[count].Text));

                    if (check == 0)
                        t.ForeColor = Color.Red;
                    else if (check == 1)
                    {
                        counter++;
                        t.ForeColor = Color.Blue;
                        t.Enabled = false;
                    }
                    else if (check == 2)
                    {
                        counter++;
                        MessageBox.Show("Congratulation");
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void pictureBox5_Click(object sender, EventArgs e)
        {
            int[] arr = new int[81];
            try
            {
                Program.print_solved_board(arr);
                for (int i = 0; i < 81; i++)
                {
                    Program.txt[i + 1].Text = arr[i].ToString();
                    Program.txt[i + 1].ForeColor = Color.Blue;
                }
                correct = Program.return_correct();
                wrong = Program.return_wrong();
                MessageBox.Show("wrong: " + wrong.ToString() + "  \n  correct: " + correct);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
           
        }

        private void textBox13_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
        }

        private void textBox1_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void btn_Clr_Click(object sender, EventArgs e)
        {
            int[] arr = new int[81];
            try
            {
                Program.clear_board(arr);
                for (int i = 0; i < 81; i++)
                {
                    if (arr[i] != 0)
                        Program.txt[i + 1].Text = arr[i].ToString();
                    else
                        Program.txt[i + 1].Text = null;

                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            correct=Program.return_correct();
            wrong = Program.return_wrong();
            MessageBox.Show("wrong: "+wrong.ToString() + "  \n  correct: " + correct);
        }

        private void Form1_Load_1(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            int level=0;

            if (comboBox1.SelectedItem.ToString() == "Easy")
                level = 1;
            if (comboBox1.SelectedItem.ToString() == "Medium")
                level = 2;
            if (comboBox1.SelectedItem.ToString() == "Hard")
                level = 3;


            int[] arr = new int[81];
            label2.Text =Program.get_Board(level ,arr).ToString();
            for (int i = 0; i < 81; i++)
            {
                if (arr[i] != 0)
                {
                    Program.txt[i + 1].Text = arr[i].ToString();
                    Program.txt[i + 1].Enabled = false;
                }
                else
                {
                    Program.txt[i + 1].Text = null;
                    Program.txt[i + 1].Enabled = true;
                }
            }

        }

        private void btn_Save_Click(object sender, EventArgs e)
        {
            Program.helper();
            Application.Exit();
            }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void lbl_Name_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void timer1_Tick(object sender, EventArgs e)
        {

        }
    }
    
}