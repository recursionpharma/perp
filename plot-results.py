import argparse
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def plot(project, results_file, image_file):
    df = pd.read_csv(results_file)
    sns_plot = sns.barplot(x='env', y='time', data=df)
    ax = plt.gca()
    ax.set_ylabel('Time (s)')
    plt.gca().set_xlabel('Environment Resolver')
    ax.set_title(f'{project.capitalize()} Environment Resolution Time')
    plt.show()
    sns_plot.figure.savefig(image_file)


def main():
    parser = argparse.ArgumentParser(
        description='Plot Python environment manager profiling results from input text file. '
                    'File must be formatted as CSV file with header \"env,time\". '
                    'Plot will be saved to an output image file.')
    parser.add_argument('-p',
                        '--project',
                        type=str,
                        default=False,
                        required=True,
                        help='Project name.')
    parser.add_argument('-f',
                        '--results-file',
                        type=str,
                        default=False,
                        required=True,
                        help='Path to the input results file.')
    parser.add_argument('-i',
                        '--image-file',
                        type=str,
                        default=False,
                        required=True,
                        help='Path to the output image file.')
    args = parser.parse_args()
    plot(args.project, args.results_file, args.image_file)


if '__main__' == __name__:
    main()
