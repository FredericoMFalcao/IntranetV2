-- -------------
--  2. EVENT HANDLERS
--
--  A table that allows modules to "listen and react" to events exported by other modules
-- -------------
CREATE TABLE SYS_EventHandlers (
  EventName VARCHAR(255) NOT NULL,
  BeforeStoredProcedure VARCHAR(255) NOT NULL,
  AfterStoredProcedure VARCHAR(255) NOT NULL,
  FOREIGN KEY (EventName) REFERENCES SYS_Events(Name)
);