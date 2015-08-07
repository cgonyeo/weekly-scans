{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

import Shelly
import Data.List

import qualified Data.Text as T

data Hostname = Hostname T.Text
              | Unknown deriving(Show,Eq,Read)

data Host = Host Hostname Text deriving(Show,Eq,Read)

main :: IO ()
main = shelly $ do
    updateRng "seen49hosts" "129.21.49.0/24"
    updateRng "seen50hosts" "129.21.50.0/24"

updateRng :: Shelly.FilePath -> T.Text -> Sh ()
updateRng file rng = do
    cmd "touch" file
    oldblob <- readfile file
    let oldhosts = if oldblob == "" then [] else read (T.unpack oldblob)
    hosts <- parseScan `fmap` cmd "nmap" "-sn" rng
    let newhosts = nub (oldhosts ++ hosts)
    writefile file (T.pack $ show newhosts)

parseScan :: T.Text -> [Host]
parseScan scan = parseScanLines $ T.lines scan

parseScanLines :: [T.Text] -> [Host]
parseScanLines [] = []
parseScanLines (x:xs) = 
    case T.words x of
        ("Nmap":"scan":ws) ->
            if (T.words $ head xs) !! 2 == "up"
                then if (T.last $ last ws) == ')'
                         then Host (Hostname $ last $ init ws)
                                   (T.init $ T.tail $ last ws)
                                 : parseScanLines xs
                         else Host Unknown (last ws) : parseScanLines xs
            else parseScanLines xs
        _ -> parseScanLines xs
