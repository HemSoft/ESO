namespace HemSoft.Eso.Viewer
{
    using System;
    using System.Windows.Forms;
    using Domain;
    using Domain.Managers;
    using Helpers;
    using System.Windows.Forms.DataVisualization.Charting;

    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            InitForm();
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            SaveFormPosition();
        }

        #region Private Helper Methods

        private void AddAccounts(TreeNodeCollection tnc)
        {
            var accounts = AccountManager.GetAll();
            foreach (var account in accounts)
            {
                var tn = tnc.Add(account.Name);
                tn.Tag = account;

                AddCharacters(tn.Nodes, account.Id);
            }
        }

        private void AddCharacters(TreeNodeCollection tnc, int accountId)
        {
            var characters = CharacterManager.GetAllByAccountId(accountId);
            foreach (var character in characters)
            {
                var tn = tnc.Add(character.Name);
                tn.Tag = character;

                //AddCharacters(tn.Nodes);
            }
        }

        private void InitForm()
        {
            this.Top = Properties.Settings.Default.FormTop;
            this.Left = Properties.Settings.Default.FormLeft;
            this.Width = Properties.Settings.Default.FormWidth;
            this.Height = Properties.Settings.Default.FormHeight;
            this.scMain.SplitterDistance = Properties.Settings.Default.MainSplitterDistance;
            InitMainTreeView();
        }

        private void InitMainTreeView()
        {
            tvMain.Nodes.Clear();
            AddAccounts(tvMain.Nodes);
        }

        private void SaveFormPosition()
        {
            Properties.Settings.Default.FormTop = this.Top;
            Properties.Settings.Default.FormLeft = this.Left;
            Properties.Settings.Default.FormWidth = this.Width;
            Properties.Settings.Default.FormHeight = this.Height;
            Properties.Settings.Default.MainSplitterDistance = this.scMain.SplitterDistance;
            Properties.Settings.Default.Save();
        }

        #endregion

        private void tvMain_AfterSelect(object sender, TreeViewEventArgs e)
        {
            if (tvMain.IsSelected<Character>())
            {
                //ShowCharacterCashHistoryChart(tvMain.Selected<Character>());
                ShowCharacterChampionPointsHistoryChart(tvMain.Selected<Character>());
            }
        }

        private void ShowCharacterCashHistoryChart(Character character)
        {
            chMain.ResetAutoValues();
            chMain.Series.Clear();
            var series1 = new Series
            {
                Name = "Cash over time",
                Color = System.Drawing.Color.Green,
                IsVisibleInLegend = true,
                IsXValueIndexed = true,
                ChartType = SeriesChartType.Area
            };

            chMain.Series.Add(series1);

            var characterActivities = CharacterActivityManager.GetAllActivityByCharacterId(character.Id);
            foreach (var characterActivity in characterActivities)
            {
                series1.Points.AddXY(characterActivity.LastLogin.Value, characterActivity.Cash);
            }
            chMain.Invalidate();
        }

        private void ShowCharacterChampionPointsHistoryChart(Character character)
        {
            chMain.ResetAutoValues();
            chMain.Series.Clear();
            var series1 = new Series
            {
                Name = "Cash over time",
                Color = System.Drawing.Color.Green,
                IsVisibleInLegend = true,
                IsXValueIndexed = true,
                ChartType = SeriesChartType.Area
            };

            chMain.Series.Add(series1);

            var characterActivities = CharacterActivityManager.GetAllActivityByCharacterId(character.Id);
            foreach (var characterActivity in characterActivities)
            {
                series1.Points.AddXY(characterActivity.LastLogin.Value, characterActivity.ChampionPointsEarned);
            }
            chMain.Invalidate();
        }

    }
}
