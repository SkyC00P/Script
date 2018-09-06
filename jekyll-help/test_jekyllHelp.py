import unittest
from jekyllHelp import *


class MyTestCase(unittest.TestCase):
    def test_something(self):
        self.assertEqual(True, False)

    def test_check_has_yaml(self):
        file = "D:\\project\\skyc00p.github.io\\_posts\\2018-07-06-初识Git.md"
        self.assertTrue(check_has_yaml(file))

        # file = "D:\\project\\Script\\jekyll-help\\test_jekyllHelp.py"
        # self.assertFalse(check_has_yaml(file))

        pass

    def test_show_gui(self):
        show_gui()
        pass

    def test_test(self):
        test()
        pass

    def test_1(self):
        get_sys_args()


if __name__ == '__main__':
    unittest.main()
