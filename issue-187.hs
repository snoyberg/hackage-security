import           Control.Concurrent                       (MVar, forkIO,
                                                           newEmptyMVar,
                                                           putMVar, takeMVar,
                                                           threadDelay)
import           Control.Exception                        (finally)
import qualified Hackage.Security.Client                  as HS
import qualified Hackage.Security.Client.Repository.Cache as HS
import qualified Hackage.Security.Util.Path               as HS
import           System.Directory                         (canonicalizePath, createDirectoryIfMissing)

update :: MVar () -> FilePath -> IO ()
update baton path = HS.lockCache cache (do
  putMVar baton ()
  threadDelay 5000000
  putStrLn "Leaving update") `finally` putMVar baton ()
  where
    cache = HS.Cache
      { HS.cacheRoot = HS.fromAbsoluteFilePath path
      , HS.cacheLayout = HS.cabalCacheLayout
      }

main :: IO ()
main = do
  createDirectoryIfMissing True "tmp"
  path <- canonicalizePath "tmp"
  baton <- newEmptyMVar
  _ <- forkIO $ update baton path
  takeMVar baton
