namespace HemSoft.Eso.Viewer.Helpers
{
    using System.Windows.Forms;

    public static class ExtensionMethods
    {
        public static bool IsSelected<T>(this TreeView treeView)
        {
            return treeView.SelectedNode?.Tag?.GetType() == typeof(T);
        }

        public static T Selected<T>(this TreeView treeView)
        {
            return (T) treeView.SelectedNode?.Tag;
        }
    }
}
