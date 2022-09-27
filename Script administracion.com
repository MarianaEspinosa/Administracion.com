-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema bancomt
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bancomt
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bancomt` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
-- -----------------------------------------------------
-- Schema mercado
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mercado
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mercado` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `cedula` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `nroVivienda` VARCHAR(45) NULL,
  `telefono` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `contraseña` VARCHAR(45) NULL,
  `fechaRegistro` DATE NULL,
  `fechaPagoOp` DATE NULL,
  `estadoPago` VARCHAR(1) NULL,
  PRIMARY KEY (`cedula`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bancomt`.`administradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bancomt`.`administradores` (
  `idAdministrador` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `idConjunto` INT NULL,
  PRIMARY KEY (`idAdministrador`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bancomt`.`conjuntos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bancomt`.`conjuntos` (
  `idConjunto` INT NOT NULL,
  `direccion` VARCHAR(45) NULL,
  `idAdministrador` INT NOT NULL,
  PRIMARY KEY (`idConjunto`),
  INDEX `fk_conjuntos_administradores_idx` (`idAdministrador` ASC) VISIBLE,
  CONSTRAINT `fk_conjuntos_administradores`
    FOREIGN KEY (`idAdministrador`)
    REFERENCES `bancomt`.`administradores` (`idAdministrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vivienda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vivienda` (
  `nroVivienda` INT NOT NULL,
  `cedula` INT NULL,
  `idConjunto` INT NOT NULL,
  PRIMARY KEY (`nroVivienda`),
  INDEX `fk_vivienda_usuario_idx` (`cedula` ASC) VISIBLE,
  INDEX `fk_vivienda_conjuntos1_idx` (`idConjunto` ASC) VISIBLE,
  CONSTRAINT `fk_vivienda_usuario`
    FOREIGN KEY (`cedula`)
    REFERENCES `mydb`.`usuario` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vivienda_conjuntos1`
    FOREIGN KEY (`idConjunto`)
    REFERENCES `bancomt`.`conjuntos` (`idConjunto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`facturas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`facturas` (
  `idFacturas` INT NOT NULL,
  `fechaPago` DATETIME NULL,
  `cedula` INT NOT NULL,
  PRIMARY KEY (`idFacturas`),
  INDEX `fk_facturas_usuario1_idx` (`cedula` ASC) VISIBLE,
  CONSTRAINT `fk_facturas_usuario1`
    FOREIGN KEY (`cedula`)
    REFERENCES `mydb`.`usuario` (`cedula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `bancomt` ;

-- -----------------------------------------------------
-- Table `bancomt`.`empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bancomt`.`empleado` (
  `documento` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `fechaContrato` DATE NOT NULL,
  PRIMARY KEY (`documento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `mercado` ;

-- -----------------------------------------------------
-- Table `mercado`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`cliente` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`proveedor` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`compra` (
  `id` INT NOT NULL,
  `id_proveedor` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `compra_proveedor_fk` (`id_proveedor` ASC) VISIBLE,
  CONSTRAINT `compra_proveedor_fk`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `mercado`.`proveedor` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`producto` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `precio` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`compra_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`compra_producto` (
  `id_compra` INT NOT NULL,
  `id_producto` INT NOT NULL,
  PRIMARY KEY (`id_compra`, `id_producto`),
  INDEX `compraPrdo_prod_fk` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `compraPrdo_prod_fk`
    FOREIGN KEY (`id_producto`)
    REFERENCES `mercado`.`producto` (`id`),
  CONSTRAINT `compraProd_compra_fk`
    FOREIGN KEY (`id_compra`)
    REFERENCES `mercado`.`compra` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`empleado` (
  `id` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `salario` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`venta` (
  `id` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_empleado` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `venta_cliente_fk` (`id_cliente` ASC) VISIBLE,
  INDEX `venta_empleado_fk` (`id_empleado` ASC) VISIBLE,
  CONSTRAINT `venta_cliente_fk`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `mercado`.`cliente` (`id`),
  CONSTRAINT `venta_empleado_fk`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `mercado`.`empleado` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mercado`.`venta_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mercado`.`venta_producto` (
  `id_venta` INT NOT NULL,
  `id_producto` INT NOT NULL,
  PRIMARY KEY (`id_venta`, `id_producto`),
  INDEX `ventaProd_prod_fk` (`id_producto` ASC) VISIBLE,
  CONSTRAINT `ventaProd_prod_fk`
    FOREIGN KEY (`id_producto`)
    REFERENCES `mercado`.`producto` (`id`),
  CONSTRAINT `ventaProd_venta_fk`
    FOREIGN KEY (`id_venta`)
    REFERENCES `mercado`.`venta` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
