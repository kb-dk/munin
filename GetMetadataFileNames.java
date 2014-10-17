
import java.io.FileNotFoundException;
import java.lang.System;
import java.util.HashMap;
import java.util.Scanner;
import java.io.File;
import java.io.FileInputStream;

public class GetMetadataFileNames {

    /*
     * utillity method to get the last element of an array
     */
    public static <T> T last(T[] array) {
        return array[array.length - 1];
    }

    /*
     * method for creating a job id index giving us O(1) look up
     */
    private static HashMap<String, Boolean> loadJobIds(String fileName) throws FileNotFoundException {
        HashMap<String, Boolean> index = new HashMap<String, Boolean>();
        Scanner jobIdFile = new Scanner(new FileInputStream(fileName));

        while (jobIdFile.hasNextLine()) {
            index.put(jobIdFile.nextLine(), Boolean.TRUE);
        }

        return index;
    }

    public static void main(String[] args) throws FileNotFoundException {
        if (args.length != 1) {
            System.err.println("You must provide a file containing job ids");
            System.err.println("GetMetadataFileNames jobidfile");
            return;
        }

        HashMap<String, Boolean> jobIdIndex = new HashMap<String, Boolean>();

        System.err.println("Load job ids from " + args[0]);
        jobIdIndex = loadJobIds(args[0]);
        System.err.println("Number of job id loaded: " + jobIdIndex.size());

        Scanner filePaths = new Scanner(System.in);
        int i = 0;

        /*
         * these file paths are of the form
         * /net/zone1.isilon.sblokalnet/ifs/archive/netarkiv/0233/filedir/199291-205-20140127203107-00021-kb-prod-har-003.kb.dk.warc
         */
        while (filePaths.hasNext()) {
            String filePath = filePaths.next();

            String jobId = last(filePath.split("/")).split("-")[0];

            if (jobIdIndex.containsKey(jobId) && filePath.contains("metadata")) {
                System.out.println(filePath);
            }

            /* progress bar */
            if (i++ > 100000) {
                System.err.print(".");
                i = 0;
            }
        }
    }
}
